package io.github.josuevele77.movie_web.model;

import java.sql.Timestamp;

public class HistorialCompra {
    private int idTransaccion;
    private String nombreUsuario;
    private String nombrePelicula;
    private Timestamp fechaCompra;
    private double total;

    // Genera el Constructor, Getters y Setters

    public HistorialCompra() {
    }

    public HistorialCompra(int idTransaccion, String nombreUsuario, String nombrePelicula, Timestamp fechaCompra, double total) {
        this.idTransaccion = idTransaccion;
        this.nombreUsuario = nombreUsuario;
        this.nombrePelicula = nombrePelicula;
        this.fechaCompra = fechaCompra;
        this.total = total;
    }

    public int getIdTransaccion() {
        return idTransaccion;
    }

    public void setIdTransaccion(int idTransaccion) {
        this.idTransaccion = idTransaccion;
    }

    public String getNombreUsuario() {
        return nombreUsuario;
    }

    public void setNombreUsuario(String nombreUsuario) {
        this.nombreUsuario = nombreUsuario;
    }

    public String getNombrePelicula() {
        return nombrePelicula;
    }

    public void setNombrePelicula(String nombrePelicula) {
        this.nombrePelicula = nombrePelicula;
    }

    public Timestamp getFechaCompra() {
        return fechaCompra;
    }

    public void setFechaCompra(Timestamp fechaCompra) {
        this.fechaCompra = fechaCompra;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }

}