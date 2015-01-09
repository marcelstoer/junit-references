package com.frightanic.junit.references;

import java.io.File;
import java.util.Map;

import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * Stores the data structure collected by the {@link ReferencesAnnotationsRunListener} as JSON.
 * Creates a "references.json" file in a defined folder.
 */
public class JsonReferencesPersister implements ReferencesPersister {

  private static final String OUTPUT_FILE_NAME = "references.json";
  private final String outputFolder;

  /**
   * Constructor.
   *
   * @param outputFolder output folder
   */
  public JsonReferencesPersister(String outputFolder) {
    this.outputFolder = outputFolder;
  }

  @Override
  public void persist(Map<String, Map<String, References>> references) {
    try {
      File outputFile = new File(outputFolder, OUTPUT_FILE_NAME).getCanonicalFile();
      new ObjectMapper().writerWithDefaultPrettyPrinter().writeValue(outputFile, references);
    } catch (Exception e) {
      throw new RuntimeException("Failed to persist references to JSON.", e);
    }
  }

}
