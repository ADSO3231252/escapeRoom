import express from "express";
import pool from "./config/db.js";
import levelRoutes from "./routes/level.routes.js";

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

app.use("/api/levels", levelRoutes);

app.get("/", (req, res) => {
    res.json({
        ok: true,
        message: "NEXUS-9 Backend funcionando"
    });
});

app.get("/api/health", async (req, res) => {
    try {
        const result = await pool.query("SELECT NOW() AS fecha");

        res.json({
            ok: true,
            message: "Backend conectado correctamente con PostgreSQL",
            database: "nexus9",
            fecha: result.rows[0].fecha
        });
    } catch (error) {
        console.error("Error de conexión:", error);

        res.status(500).json({
            ok: false,
            message: "No se pudo conectar con PostgreSQL"
        });
    }
});

app.use((req, res) => {
    res.status(404).json({
        ok: false,
        message: "Ruta no encontrada"
    });
});

app.listen(PORT, () => {
    console.log(
        `NEXUS-9 Backend ejecutándose en http://localhost:${PORT}`
    );
});