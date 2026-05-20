package com.ecommerce.common.exception;

/**
 * Exception thrown when an operation is unauthorized
 */
public class UnauthorizedException extends ECommerceException {

    public UnauthorizedException(String message) {
        super(message, "UNAUTHORIZED", 401);
    }

    public UnauthorizedException(String message, Throwable cause) {
        super(message, cause, "UNAUTHORIZED", 401);
    }
}

