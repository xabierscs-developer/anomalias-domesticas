package com.example.anomalias.entity;

import com.example.anomalias.enums.Disciplina;
import com.example.anomalias.enums.EstadoAnomalia;
import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Table(name = "anomalias")
@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Anomalia {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 150)
    private String titulo;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String descripcion;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private Disciplina disciplina;
    
    @Column(nullable = false)
    private int peligrosidad;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private EstadoAnomalia estado = EstadoAnomalia.REPORTADA;

    @Column(nullable = false, name = "fecha_reporte")
    private LocalDateTime fechaReporte;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "vivienda_id", nullable = false)
    private Vivienda vivienda;
}
