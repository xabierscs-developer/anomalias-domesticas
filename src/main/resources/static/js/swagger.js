"use strict";

async function initializeSwagger() {
    const status = document.getElementById("swagger-status");

    try {
        if (typeof SwaggerUIBundle !== "function") {
            throw new Error(
                "No se pudo cargar Swagger UI. Comprueba tu conexión a Internet o el acceso a cdn.jsdelivr.net.",
            );
        }

        const specUrl = new URL("openapi.json", window.location.href);
        const response = await fetch(specUrl, { cache: "no-cache" });

        if (!response.ok) {
            throw new Error(
                `No se pudo cargar el contrato OpenAPI (HTTP ${response.status}).`,
            );
        }

        const spec = await response.json();

        // Las peticiones siempre apuntan al servidor desde el que se abrió esta página,
        // incluyendo su puerto y, si existe, el context-path de Spring Boot.
        const applicationUrl = new URL(".", specUrl);
        spec.servers = [
            {
                url: applicationUrl.href.replace(/\/$/, ""),
                description: "Esta aplicación · entorno local",
            },
        ];

        window.ui = SwaggerUIBundle({
            spec,
            dom_id: "#swagger-ui",
            deepLinking: true,
            docExpansion: "list",
            defaultModelsExpandDepth: -1,
            displayRequestDuration: true,
            filter: true,
            persistAuthorization: false,
            validatorUrl: null,
            supportedSubmitMethods: ["get", "post", "patch"],
            presets: [SwaggerUIBundle.presets.apis],
            layout: "BaseLayout",
            onComplete: () => {
                status.hidden = true;
            },
        });
    } catch (error) {
        status.textContent =
            error instanceof Error
                ? error.message
                : "No se pudo abrir la documentación.";
        status.classList.add("status-error");
    }
}

initializeSwagger();
