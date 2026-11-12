package com.example.anomalias.dto.response;

public record ViviendaResponse (
    Long id,
    String direccion,
    String residente,
    String email,
    String intruccionesAcceso
)
{
}
