package com.example.anomalias.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import lombok.*;

@Entity
@Table(name = "viviendas")
@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Vivienda {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 200)
    private String direccion;

    @Column(nullable = false, length = 100)
    private String residente;

    @Email
    @Column(nullable = false, length = 150, name = "email_contacto")
    private String email;

    @Column(name = "instrucciones_acceso", length = 500)
    private String instruccionesAcceso;

}
