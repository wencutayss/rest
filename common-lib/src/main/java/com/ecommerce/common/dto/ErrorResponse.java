package com.ecommerce.common.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * Error Response DTO for handling errors across all microservices
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ErrorResponse {

    /**
     * HTTP Status code
     */
    private int status;

    /**
     * Error code for programmatic handling
     */
    private String errorCode;

    /**
     * Human-readable error message
     */
    private String message;

    /**
     * Detailed error description
     */
    private String description;

    /**
     * Unique identifier for this error instance
     */
    private String errorId;

    /**
     * Request ID that caused the error
     */
    private String requestId;

    /**
     * Path that triggered the error
     */
    private String path;

    /**
     * Timestamp when error occurred
     */
    private LocalDateTime timestamp;

    /**
     * Map of field-level validation errors
     * Key: field name, Value: error message
     */
    private Map<String, String> fieldErrors;

    /**
     * Builder method for creating error responses
     */
    public static ErrorResponse error(int status, String errorCode, String message) {
        return ErrorResponse.builder()
                .status(status)
                .errorCode(errorCode)
                .message(message)
                .timestamp(LocalDateTime.now())
                .build();
    }

    /**
     * Builder method for creating error responses with description
     */
    public static ErrorResponse error(int status, String errorCode, String message, String description) {
        return ErrorResponse.builder()
                .status(status)
                .errorCode(errorCode)
                .message(message)
                .description(description)
                .timestamp(LocalDateTime.now())
                .build();
    }

    /**
     * Add field-level validation error
     */
    public void addFieldError(String fieldName, String errorMessage) {
        if (this.fieldErrors == null) {
            this.fieldErrors = new HashMap<>();
        }
        this.fieldErrors.put(fieldName, errorMessage);
    }
}

