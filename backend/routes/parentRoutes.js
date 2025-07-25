const express = require('express');
const router = express.Router();
const { verifyToken } = require('../middlewares/authMiddleware');
const parentController = require('../controllers/parentController');

// Obtener hijos del padre autenticado
router.get('/children', verifyToken, parentController.getChildren);

// Obtener calificaciones por hijo y asignatura
router.get('/:studentId/grades', verifyToken, parentController.getStudentGrades);

// Obtener desglose de calificaciones por tarea en una asignatura
router.get('/:studentId/grades/:subjectId/tasks', verifyToken, parentController.getStudentTaskGrades);

// Obtener historial de pagos por hijo (con filtros de fecha opcionales)
router.get('/:studentId/payments', verifyToken, parentController.getChildPaymentHistory);

// Obtener pagos pendientes por hijo
router.get('/:studentId/payments/pending', verifyToken, parentController.getChildPendingPayments);

module.exports = router;
