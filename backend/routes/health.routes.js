import { Router } from "express";

const router = Router();

router.get("/", (req, res) => {
    res.json({
        ok: true,
        message: "NEXUS-9 API funcionando"
    });
});

export default router;