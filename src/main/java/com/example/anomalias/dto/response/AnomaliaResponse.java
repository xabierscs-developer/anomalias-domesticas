package com.example.anomalias.dto.response;

import com.example.anomalias.enums.Disciplina;
import com.example.anomalias.enums.EstadoAnomalia;

import java.time.LocalDateTime;

public record AnomaliaResponse(
    Long id,
    ViviendaResponse vivienda,
    String titulo,
    String descripcion,
    Disciplina disciplina,
    int peligrosidad,
    EstadoAnomalia estado,
    LocalDateTime fechaReporte
)
{
}
