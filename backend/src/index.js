require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
const bcrypt = require('bcryptjs');

const app = express();
const port = process.env.PORT || 3000;

// Middlewares
app.use(cors());
app.use(express.json());

// Conexión a la base de datos
const pool = new Pool({
    host: process.env.DB_HOST || 'db',
    port: process.env.DB_PORT || 5432,
    user: process.env.DB_USER || 'postgres',
    password: process.env.DB_PASSWORD || 'postgres',
    database: process.env.DB_NAME || 'auth_db',
});

// ENDPOINT: Registro de usuario
app.post('/auth/register', async (req, res) => {
    try {
        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({ error: 'Email y password son requeridos' });
        }

        if (!email.includes('@') || !email.includes('.')) {
            return res.status(400).json({ error: 'Email inválido' });
        }

        const password_hash = bcrypt.hashSync(password, 10);

        const result = await pool.query(
            'INSERT INTO users (email, password_hash) VALUES ($1, $2) RETURNING id',
            [email, password_hash]
        );

        res.status(201).json({
            message: 'Usuario creado exitosamente',
            userId: result.rows[0].id
        });

    } catch (error) {
        if (error.code === '23505') {
            return res.status(400).json({ error: 'El email ya está registrado' });
        }
        console.error(error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

app.get('/health', (req, res) => {
    res.json({ status: 'Server is running' });
});

app.listen(port, () => {
    console.log(`🚀 Servidor corriendo en http://localhost:${port}`);
});