package com.frightanic.junit.references;

import java.util.Map;

/**
 * Persists the references (from annotations) picked up by the run listener.
 */
public interface ReferencesPersister {

  /**
   * Persists the references picked up by the run listener.
   *
   * @param references organized top-down with the two map keys being class name and method name
   */
  void persist(Map<String, Map<String, References>> references);
}
