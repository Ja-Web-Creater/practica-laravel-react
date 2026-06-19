import React from 'react';

export default function Practica({ status, fecha }) {
    return (
        <div style={{
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
            justifyContent: 'center',
            height: '100vh',
            fontFamily: 'sans-serif',
            backgroundColor: '#0f172a',
            color: '#f8fafc'
        }}>
            <h1 style={{ color: '#38bdf8', marginBottom: '10px' }}>
                🚀 Mi Práctica Simple
            </h1>
            <p style={{ fontSize: '1.2rem', fontWeight: 'bold' }}>{status}</p>
            <p style={{ color: '#94a3b8', marginTop: '20px' }}>
                Hora del servidor: <span style={{ color: '#34d399' }}>{fecha}</span>
            </p>

            <div style={{ marginTop: '30px' }}>
                <a href="/login" style={{
                    padding: '10px 20px',
                    backgroundColor: '#3b82f6',
                    color: 'white',
                    textDecoration: 'none',
                    borderRadius: '5px',
                    marginRight: '10px'
                }}>Iniciar Sesión</a>

                <a href="/register" style={{
                    padding: '10px 20px',
                    backgroundColor: '#10b981',
                    color: 'white',
                    textDecoration: 'none',
                    borderRadius: '5px'
                }}>Registrarse</a>
            </div>
        </div>
    );
}
