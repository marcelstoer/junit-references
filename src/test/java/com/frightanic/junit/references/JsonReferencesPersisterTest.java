package com.frightanic.junit.references;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.io.IOUtils;
import org.junit.Test;

import static org.hamcrest.Matchers.is;
import static org.junit.Assert.assertThat;

/**
 * Tests {@link JsonReferencesPersister}.
 */
public class JsonReferencesPersisterTest {

  private static final String LS = System.getProperty("line.separator");
  private static final String FILE_NAME = "references.json";

  /**
   * See method name.
   */
  @Test
  public void shouldWriteEmptyJsonFileForNoReferences() {
    // given
    Map<String, Map<String, References>> references = new HashMap<>();
    // when
    new JsonReferencesPersister("./target").persist(references);
    // then
    assertThat(readJsonString(), is("{ }"));
  }

  /**
   * See method name.
   */
  @Test
  public void shouldWriteJsonForRegularInput() {
    // given
    Map<String, Map<String, References>> classReferences = new HashMap<>();
    Map<String, References> methodReferences = new HashMap<>();
    final References refs = new References();
    refs.getRequirements().add("req-1");
    refs.getRisks().add("risk_1");
    methodReferences.put("methodName", refs);
    classReferences.put("className", methodReferences);
    // when
    new JsonReferencesPersister("./target").persist(classReferences);
    // then
    assertThat(readJsonString(), is("{" + LS + "  \"className\" : {" + LS
        + "    \"methodName\" : {" + LS + "      \"requirements\" : [ \"req-1\" ]," + LS
        + "      \"risks\" : [ \"risk_1\" ]" + LS + "    }" + LS + "  }" + LS + "}"));
  }

  private String readJsonString() {
    try {
      return IOUtils.toString(new File("./target", FILE_NAME).toURI());
    } catch (IOException e) {
      throw new RuntimeException("Failed to read '" + FILE_NAME + "'.", e);
    }
  }
}
