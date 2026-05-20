package com.ecommerce.common.util;

import java.util.UUID;

/**
 * Utility class for common operations across microservices
 */
public class CommonUtils {

    /**
     * Generate a unique ID
     */
    public static String generateId() {
        return UUID.randomUUID().toString();
    }

    /**
     * Generate a unique correlation/request ID
     */
    public static String generateRequestId() {
        return UUID.randomUUID().toString();
    }

    /**
     * Check if a string is null or empty
     */
    public static boolean isNullOrEmpty(String value) {
        return value == null || value.isEmpty();
    }

    /**
     * Check if a string is not null and not empty
     */
    public static boolean isNotNullOrEmpty(String value) {
        return !isNullOrEmpty(value);
    }
}

