package com.example.anomalias.exception.dto;

import java.time.LocalDateTime;

public record ErrorResponse(
    LocalDateTime timestamp,
    String error,
    String message,
    String path
) {
}
