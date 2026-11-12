package com.example.anomalias.controller;

import com.example.anomalias.dto.response.AnomaliaResponse;
import com.example.anomalias.entity.Anomalia;
import com.example.anomalias.service.AnomaliaService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/anomalias")
@RequiredArgsConstructor
public class AnomaliaController {

    private final AnomaliaService anomaliaService;

    @GetMapping
    public List<AnomaliaResponse> getAllAnomalias() {
        return anomaliaService.findAll();
    }

    @GetMapping("/{id}")
    public AnomaliaResponse getAnomaliaById(@PathVariable Long id) {
        return anomaliaService.findById(id);
    }
}
