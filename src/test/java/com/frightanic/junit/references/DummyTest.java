package com.frightanic.junit.references;

import org.junit.Test;

import static org.junit.Assert.assertTrue;

//CHECKSTYLE:OFF
@Risk(references = "risk_1")
public class DummyTest {

  @Test
  @Requirement(references = {"req-1", "req-2"})
  public void test1() {
    assertTrue(true);
  }

  @Test
  @Risk(references = "risk_2")
  public void test2() {
    assertTrue(true);
  }

  @Test
  public void test3() {
    assertTrue(true);
  }

}
