package com.frightanic.junit.references;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

import org.apache.commons.io.IOUtils;
import org.junit.Test;
import org.junit.runner.JUnitCore;
import org.junit.runner.Result;

import static org.hamcrest.Matchers.is;
import static org.junit.Assert.assertThat;
import static org.junit.Assert.assertTrue;

// CHECKSTYLE:OFF
public class ReferencesAnnotationsRunListenerTest {

  private static final String SUREFIRE_FOLDER = "target/surefire-reports";

  @Test
  public void shouldCreateReferencesJson() throws IOException {
    // given, if running from within IDE the Surefire files don't exist...create them
    createFakeSurefileArtifact();

    // when
    JUnitCore runner = new JUnitCore();
    runner.addListener(new ReferencesAnnotationsRunListener());
    Result result = runner.run(DummyTest.class);

    // then
    assertTrue(result.getFailureCount() == 0);
    assertThat(new File(SUREFIRE_FOLDER, "references.json").exists(), is(true));
  }

  private void createFakeSurefileArtifact() throws IOException {
    String xml = "<?xml version='1.0' encoding='UTF-8'?>";
    xml += "<testsuite name='DummyTest' time='0' tests='3' errors='0' skipped='0' failures='0'>";
    xml += "  <testcase name='test1' classname='DummyTest' time='0'/>";
    xml += "  <testcase name='test2' classname='DummyTest' time='0'/>";
    xml += "  <testcase name='test3' classname='DummyTest' time='0'/>";
    xml += "</testsuite>";
    File fakeSurefireFolder = new File(SUREFIRE_FOLDER);
    File fakeSurefireFile = new File(fakeSurefireFolder, "TEST-" + DummyTest.class.getName()
        + ".xml");
    if (!fakeSurefireFolder.exists()) {
      assertTrue(fakeSurefireFolder.mkdirs());
    }
    IOUtils.write(xml, new FileOutputStream(fakeSurefireFile), "utf-8");
  }
}
