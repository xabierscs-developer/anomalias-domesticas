package com.example.anomalias.service;

import com.example.anomalias.dto.response.AnomaliaResponse;
import com.example.anomalias.dto.response.ViviendaResponse;
import com.example.anomalias.entity.Anomalia;
import com.example.anomalias.entity.Vivienda;
import com.example.anomalias.exception.RecursoNoEncontradoException;
import com.example.anomalias.repository.AnomaliaRepository;
import org.springframework.transaction.annotation.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AnomaliaService {

    private final AnomaliaRepository anomaliaRepository;

    @Transactional(readOnly = true)
    public List<AnomaliaResponse> findAll() {
        return anomaliaRepository.findAll()
            .stream()
            .map(this::toResponse)
            .toList();
    }

    @Transactional(readOnly = true)
    public AnomaliaResponse findById(Long id) {
        Anomalia anomalia = anomaliaRepository.findById(id)
            .orElseThrow(() -> new RecursoNoEncontradoException("Anomalia not found with id: " + id));
        return toResponse(anomalia);
    }

    public AnomaliaResponse toResponse(Anomalia anomalia) {

        Vivienda vivienda = anomalia.getVivienda();

        ViviendaResponse viviendaResponse = new ViviendaResponse(
                vivienda.getId(),
                vivienda.getDireccion(),
                vivienda.getResidente(),
                vivienda.getEmail(),
                vivienda.getInstruccionesAcceso()
        );

        return new AnomaliaResponse(
                anomalia.getId(),
                viviendaResponse,
                anomalia.getTitulo(),
                anomalia.getDescripcion(),
                anomalia.getDisciplina(),
                anomalia.getPeligrosidad(),
                anomalia.getEstado(),
                anomalia.getFechaReporte()
        );

    }
}
