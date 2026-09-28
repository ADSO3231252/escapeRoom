import { Router } from "express";
import pool from "../config/db.js";

const router = Router();

router.get("/", async (req, res) => {
    try {
        const result = await pool.query(`
      SELECT
        id,
        name,
        description,
        difficulty,
        locked
      FROM levels
      ORDER BY id
    `);

        res.json({
            ok: true,
            levels: result.rows
        });
    } catch (error) {
        console.error("Error al obtener niveles:", error);

        res.status(500).json({
            ok: false,
            message: "Error al obtener los niveles"
        });
    }
});

export default router;