package com.example.anomalias.entity;

import com.example.anomalias.enums.Disciplina;
import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
@Table(name = "especialistas")
public class Especialista {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 100)
    private String nombre;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private Disciplina disciplina;

    @Column(nullable = false, name = "nivel_autorizacion")
    private int nivelAutorizacion;

    @Column(nullable = false)
    private boolean activo;

}
