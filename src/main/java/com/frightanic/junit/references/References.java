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

import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Collection of references related to the supported annotations.
 */
@JsonAutoDetect
class References {

  @JsonInclude(value = Include.NON_EMPTY)
  @JsonProperty
  private final List<String> requirements = new ArrayList<>();

  @JsonProperty
  @JsonInclude(value = Include.NON_EMPTY)
  private final List<String> risks = new ArrayList<>();

  public List<String> getRequirements() {
    return requirements;
  }

  public List<String> getRisks() {
    return risks;
  }
}
