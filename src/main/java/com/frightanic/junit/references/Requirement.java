package com.frightanic.junit.references;

import java.lang.annotation.Documented;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import static java.lang.annotation.ElementType.METHOD;
import static java.lang.annotation.ElementType.TYPE;

/**
 * Annotation to denote references to a requirements. Requirements are usually managed in JIRA or
 * some other form, they all have an ID.
 */
// CHECKSTYLE:OFF
@Documented
@Retention(RetentionPolicy.RUNTIME)
@Target({METHOD, TYPE})
public @interface Requirement {

  String[] references();
}
