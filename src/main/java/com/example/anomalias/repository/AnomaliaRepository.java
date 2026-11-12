package com.example.anomalias.repository;

import com.example.anomalias.entity.Anomalia;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AnomaliaRepository extends JpaRepository<Anomalia, Long> {
}
