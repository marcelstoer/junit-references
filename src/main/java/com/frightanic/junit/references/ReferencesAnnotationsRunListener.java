package com.frightanic.junit.references;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import org.junit.runner.Description;
import org.junit.runner.Result;
import org.junit.runner.notification.RunListener;

/**
 * Processes all {@link Risk} and {@link Requirement} annotations (aka "supported" annotations) on
 * test classes and methods and persists this information at the end of the test run. Persisting is
 * delegated to {@link SurefireXmlReferencesPersister} & {@link JsonReferencesPersister}.
 * <p>
 * As soon as a test is triggered ({@link RunListener#testStarted(Description)}) supported
 * annotations on test class/method are parsed and their information stored in an internal data
 * structure. An annotation on the test class is thereby considered to be applicable for all test
 * methods. Once the test run is finished ({@link RunListener#testRunFinished(Result)}) the
 * aggregated annotation data is persisted.
 * </p>
 */
public class ReferencesAnnotationsRunListener extends RunListener {

  // default output folder
  private static final String SUREFIRE_REPORTS_FOLDER = "target/surefire-reports";

  // key of the 1st map is the test class name, key of the 2nd map the test method name
  private final Map<String, Map<String, References>> references = new HashMap<>();

  private final String outputFolder;

  /**
   * Constructor that defines the output folder to be relative to the current dir at
   * "target/surefire-reports".
   */
  public ReferencesAnnotationsRunListener() {
    this(SUREFIRE_REPORTS_FOLDER);
  }

  /**
   * Constructor.
   *
   * @param outputFolder output folder to be relative to the current dir
   */
  public ReferencesAnnotationsRunListener(String outputFolder) {
    this.outputFolder = outputFolder;
  }

  @Override
  public void testRunFinished(Result result) {
    if (!references.isEmpty()) {
      new SurefireXmlReferencesPersister(outputFolder).persist(references);
      new JsonReferencesPersister(outputFolder).persist(references);
    }
  }

  @Override
  public void testStarted(Description description) {
    addAllRequirements(description);
    addAllRisks(description);
  }

  private void addAllRequirements(Description description) {
    Class<?> testClass = description.getTestClass();
    String methodName = description.getMethodName();

    Requirement classRequirementAnnotation = testClass.getAnnotation(Requirement.class);
    Requirement methodRequirementAnnotation = description.getAnnotation(Requirement.class);
    if (methodRequirementAnnotation != null) {
      addRequirements(testClass.getName(), methodName, methodRequirementAnnotation.references());
    }
    if (classRequirementAnnotation != null) {
      addRequirements(testClass.getName(), methodName, classRequirementAnnotation.references());
    }
  }

  private void addAllRisks(Description description) {
    Class<?> testClass = description.getTestClass();
    String methodName = description.getMethodName();

    Risk classRiskAnnotation = testClass.getAnnotation(Risk.class);
    Risk methodRiskAnnotation = description.getAnnotation(Risk.class);
    if (methodRiskAnnotation != null) {
      addRisks(testClass.getName(), methodName, methodRiskAnnotation.references());
    }
    if (classRiskAnnotation != null) {
      addRisks(testClass.getName(), methodName, classRiskAnnotation.references());
    }
  }

  private void addRequirements(String className, String methodName, String[] references) {
    References methodReferences = getMethodReferences(className, methodName);
    Collections.addAll(methodReferences.getRequirements(), references);
  }

  private void addRisks(String className, String methodName, String[] references) {
    References methodReferences = getMethodReferences(className, methodName);
    Collections.addAll(methodReferences.getRisks(), references);
  }

  private References getMethodReferences(String className, String methodName) {
    Map<String, References> classReferences = getClassReferences(className);
    References methodReferences = classReferences.get(methodName);
    if (methodReferences == null) {
      methodReferences = new References();
      classReferences.put(methodName, methodReferences);
    }
    return methodReferences;
  }

  private Map<String, References> getClassReferences(String className) {
    Map<String, References> classReferences = references.get(className);
    if (classReferences == null) {
      classReferences = new HashMap<>();
      references.put(className, classReferences);
    }
    return classReferences;
  }
}
