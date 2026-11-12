package com.example.anomalias.entity;

import com.example.anomalias.enums.ResultadoIntervencion;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "intervenciones")
@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Intervencion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, name = "fecha_inicio")
    private LocalDateTime fechaInicio;

    @Column(name = "fecha_fin", nullable = true)
    private LocalDateTime fechaFin;

    @Enumerated(EnumType.STRING)
    @Column(length = 20)
    private ResultadoIntervencion resultado;

    @Column(length = 1500)
    private String informe;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "anomalia_id", nullable = false)
    private Anomalia anomalia;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "especialista_id", nullable = false)
    private Especialista especialista;

}
