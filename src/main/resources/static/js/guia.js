"use strict";

// Ejemplos educativos: este archivo no consulta la API ni modifica MySQL.
const outcomes = {
    CONTENIDA: {
        title: "La nevera vuelve a obedecer al presente.",
        description:
            "La anomalía queda contenida. El intento se cierra y la especialista puede atender otro caso.",
        state: "CONTENIDA",
        danger: "3 → 3",
        report: "Se aisló la nevera del próximo jueves. Ya solo conserva comida.",
    },
    SIN_CAMBIOS: {
        title: "Los imanes siguen llegando de mañana.",
        description:
            "La anomalía vuelve a reportada para que pueda intentarse otra estrategia. Se conserva el informe y la especialista queda libre.",
        state: "REPORTADA",
        danger: "3 → 3",
        report: "Cambiar el enchufe no tuvo efecto. Los mensajes siguen adelantándose un día.",
    },
    EMPEORADA: {
        title: "Ahora hay una segunda cocina del próximo jueves.",
        description:
            "La anomalía se desborda y aumenta un nivel de peligrosidad. La intervención se cierra, pero el problema necesita un nuevo intento.",
        state: "DESBORDADA",
        danger: "3 → 4",
        report: "Al desenchufar la nevera apareció una segunda cocina correspondiente al próximo jueves.",
    },
};

const outcomeButtons = document.querySelectorAll("[data-outcome]");

for (const button of outcomeButtons) {
    button.disabled = false;
    button.addEventListener("click", () => {
        const result = button.dataset.outcome;
        const example = outcomes[result];

        for (const other of outcomeButtons) {
            other.setAttribute("aria-pressed", String(other === button));
        }

        document.getElementById("outcome-title").textContent = example.title;
        document.getElementById("outcome-description").textContent =
            example.description;
        document.getElementById("outcome-state").textContent = example.state;
        document.getElementById("outcome-danger").textContent = example.danger;
        document.getElementById("example-close").textContent = JSON.stringify(
            {
                resultado: result,
                informe: example.report,
            },
            null,
            2,
        );
    });
}

const priorityForm = document.getElementById("priority-form");
const dangerInput = document.getElementById("priority-danger");
const daysInput = document.getElementById("priority-days");
const stateInput = document.getElementById("priority-state");
const scoreOutput = document.getElementById("priority-score");
const explanation = document.getElementById("priority-explanation");

function updatePriorityExample() {
    if (!priorityForm.checkValidity()) {
        scoreOutput.value = "—";
        explanation.textContent =
            "Indica una peligrosidad entera entre 1 y 5 y días completos entre 0 y 36500.";
        return;
    }

    if (stateInput.value === "EN_ESTUDIO" || stateInput.value === "CONTENIDA") {
        scoreOutput.value = "0";
        explanation.textContent =
            "No está pendiente de asignación: su prioridad es 0.";
        return;
    }

    const danger = dangerInput.valueAsNumber;
    const days = Math.min(daysInput.valueAsNumber, 7);
    const extra = stateInput.value === "DESBORDADA" ? 20 : 0;
    const score = danger * 10 + days * 2 + extra;

    scoreOutput.value = String(score);
    explanation.textContent = `${danger} × 10 + ${days} × 2${extra ? " + 20" : ""} = ${score} puntos.${daysInput.valueAsNumber > 7 ? " Solo cuentan los primeros siete días." : ""}`;
}

priorityForm.addEventListener("input", updatePriorityExample);
priorityForm.addEventListener("change", updatePriorityExample);
priorityForm.addEventListener("submit", (event) => {
    event.preventDefault();
});
updatePriorityExample();

const copyStatus = document.getElementById("copy-status");
let statusTimeout;

for (const button of document.querySelectorAll("[data-copy]")) {
    button.hidden = false;
    button.addEventListener("click", async () => {
        const source = document.getElementById(button.dataset.copy);
        clearTimeout(statusTimeout);

        try {
            await navigator.clipboard.writeText(source.textContent.trim());
            copyStatus.textContent =
                "Ejemplo copiado. Puedes pegarlo en Swagger cuando implementes el endpoint.";
        } catch {
            copyStatus.textContent =
                "No se pudo acceder al portapapeles. Selecciona el ejemplo y cópialo manualmente.";
        }

        statusTimeout = setTimeout(() => {
            copyStatus.textContent = "";
        }, 6000);
    });
}
