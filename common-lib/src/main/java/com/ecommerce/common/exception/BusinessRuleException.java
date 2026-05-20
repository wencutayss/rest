package com.ecommerce.common.exception;

/**
 * Exception thrown when a business rule is violated
 */
public class BusinessRuleException extends ECommerceException {

    public BusinessRuleException(String message) {
        super(message, "BUSINESS_RULE_VIOLATION", 422);
    }

    public BusinessRuleException(String message, Throwable cause) {
        super(message, cause, "BUSINESS_RULE_VIOLATION", 422);
    }
}

