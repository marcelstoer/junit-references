package com.frightanic.junit.references;

import java.lang.annotation.Documented;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import static java.lang.annotation.ElementType.METHOD;
import static java.lang.annotation.ElementType.TYPE;

/**
 * Annotation to denote references to a risks. Risks are usually managed in Infostore or some other
 * form.
 */
// CHECKSTYLE:OFF
@Documented
@Retention(RetentionPolicy.RUNTIME)
@Target({METHOD, TYPE})
public @interface Risk {

  String[] references();
}
