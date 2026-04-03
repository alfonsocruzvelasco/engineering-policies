# Plantilla de prompt — ChatGPT (modo Hard Constraint)

**Version:** v3 (platform override)

> Base: prompt-template.md (v3) — GSD phases, forbidden list, and golden rule are identical

**Ejecución canónica:** Task Card, Spec–Plan–Patch–Verify y puntos de verificación están en `prompt-template.md` (v3); no se duplican aquí. Este archivo añade solo la capa Hard Constraint y el ejemplo en español.

---

## 🎯 OBJETIVO

<Define en 1 línea exactamente qué quieres obtener>

---

## 🔒 CONSTRAINTS (NO NEGOCIABLES)

* <Constraint 1>
* <Constraint 2>
* <Constraint 3>
* <Constraint 4>

---

## 🚫 PROHIBIDO

* <Qué NO debe ocurrir>
* <Errores típicos a evitar>
* <Optimizaciones que NO quieres>

---

## 🧱 FORMA DE TRABAJO

* Rehacer desde cero (no iterar sobre versiones previas)
* Priorizar constraints sobre cualquier otro criterio
* No añadir contenido no solicitado

---

## ✔️ VALIDACIÓN OBLIGATORIA

Antes de responder, verifica:

* ¿Cumple TODOS los constraints?
* ¿Hay desviaciones?

Si NO cumple:
→ NO respondas con solución parcial
→ Rehaz internamente hasta cumplir

---

## 📦 OUTPUT

<Formato exacto que quieres>

---

# 🎯 EJEMPLO REAL (tu caso LaTeX)

Para que veas cómo usarlo:

## 🎯 OBJETIVO

Generar documento LaTeX A4 listo para imprimir

## 🔒 CONSTRAINTS

* EXACTAMENTE 2 páginas
* Sangría fuerte (≥ 3em)
* Alta legibilidad (no densidad)
* Jerarquía visual clara

## 🚫 PROHIBIDO

* Compactar texto para que “quepa”
* Reducir márgenes agresivamente
* Ignorar sangría
* Reutilizar versiones previas

## 🧱 FORMA DE TRABAJO

* Rehacer desde cero
* No optimizar nada fuera de constraints

## ✔️ VALIDACIÓN

Si no cumple todo → rehacer antes de responder

## 📦 OUTPUT

Código LaTeX completo, limpio, compilable

---

# KEY / REGLA DE ORO (fuente única en inglés)

**No duplicar:** la sección **KEY (why this works)** y la **GOLDEN RULE** están en `prompt-template-chatgpt-en.md` (`# 🧠 KEY` y `# ⚠️ GOLDEN RULE`). Mismo criterio normativo; léelas allí.

**Mensaje de cierre en español (para copiar en el chat):**

> **"No cumple constraints. Rehacer desde cero."**
