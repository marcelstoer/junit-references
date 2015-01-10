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
