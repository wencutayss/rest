package com.ecommerce.common.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.domain.Page;
import java.util.List;

/**
 * Paginated Response DTO for list endpoints
 * Provides pagination metadata along with the data
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@JsonInclude(JsonInclude.Include.NON_NULL)
public class PaginatedResponse<T> {

    /**
     * Current page number (0-indexed)
     */
    private int pageNumber;

    /**
     * Page size (number of items per page)
     */
    private int pageSize;

    /**
     * Total number of pages
     */
    private int totalPages;

    /**
     * Total number of items across all pages
     */
    private long totalElements;

    /**
     * Whether this is the first page
     */
    private boolean first;

    /**
     * Whether this is the last page
     */
    private boolean last;

    /**
     * Whether the current page has any elements
     */
    private boolean empty;

    /**
     * List of items in current page
     */
    private List<T> content;

    /**
     * Number of items in current page
     */
    private int numberOfElements;

    /**
     * Builder method from Spring Data Page
     */
    public static <T> PaginatedResponse<T> fromPage(Page<T> page) {
        return PaginatedResponse.<T>builder()
                .pageNumber(page.getNumber())
                .pageSize(page.getSize())
                .totalPages(page.getTotalPages())
                .totalElements(page.getTotalElements())
                .first(page.isFirst())
                .last(page.isLast())
                .empty(page.isEmpty())
                .content(page.getContent())
                .numberOfElements(page.getNumberOfElements())
                .build();
    }

    /**
     * Builder method with manual construction
     */
    public static <T> PaginatedResponse<T> of(List<T> content, int pageNumber, int pageSize,
                                               long totalElements, int totalPages) {
        return PaginatedResponse.<T>builder()
                .content(content)
                .pageNumber(pageNumber)
                .pageSize(pageSize)
                .totalElements(totalElements)
                .totalPages(totalPages)
                .numberOfElements(content.size())
                .first(pageNumber == 0)
                .last(pageNumber >= totalPages - 1)
                .empty(content.isEmpty())
                .build();
    }
}

