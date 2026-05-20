package com.ecommerce.common.exception;

/**
 * Base exception class for all eCommerce application exceptions
 */
public class ECommerceException extends RuntimeException {

    private final String errorCode;
    private final int httpStatusCode;

    public ECommerceException(String message, String errorCode, int httpStatusCode) {
        super(message);
        this.errorCode = errorCode;
        this.httpStatusCode = httpStatusCode;
    }

    public ECommerceException(String message, Throwable cause, String errorCode, int httpStatusCode) {
        super(message, cause);
        this.errorCode = errorCode;
        this.httpStatusCode = httpStatusCode;
    }

    public String getErrorCode() {
        return errorCode;
    }

    public int getHttpStatusCode() {
        return httpStatusCode;
    }
}

