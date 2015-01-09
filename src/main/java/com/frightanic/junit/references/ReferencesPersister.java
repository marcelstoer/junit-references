/*
 * Copyright (C) 2014 by Netcetera AG.
 * All rights reserved.
 *
 * The copyright to the computer program(s) herein is the property of Netcetera AG, Switzerland.
 * The program(s) may be used and/or copied only with the written permission of Netcetera AG or
 * in accordance with the terms and conditions stipulated in the agreement/contract under which
 * the program(s) have been supplied.
 */
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
