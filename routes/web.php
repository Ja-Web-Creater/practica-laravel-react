<?php

use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

Route::get('/', function () {
    return Inertia::render('Practica', [
        'status' => '¡Conexión Exitosa con React y Supabase!',
        'fecha' => date('Y-m-d H:i:s')
    ]);
});

// Nota: Abajo deja las rutas de Auth que creó Breeze, esas no las borres.
require __DIR__.'/auth.php';
