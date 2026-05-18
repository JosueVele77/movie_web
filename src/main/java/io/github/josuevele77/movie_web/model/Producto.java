package io.github.josuevele77.movie_web.model;

public class Producto {
    private int idPr;
    private int idCat;
    private String nombrePr;
    private int cantidadPr;
    private double precioPr;
    private boolean estadoPr; // true = visible, false = oculto

    public Producto() {}

    // Getters y Setters
    public int getIdPr() { return idPr; }
    public void setIdPr(int idPr) { this.idPr = idPr; }
    public int getIdCat() { return idCat; }
    public void setIdCat(int idCat) { this.idCat = idCat; }
    public String getNombrePr() { return nombrePr; }
    public void setNombrePr(String nombrePr) { this.nombrePr = nombrePr; }
    public int getCantidadPr() { return cantidadPr; }
    public void setCantidadPr(int cantidadPr) { this.cantidadPr = cantidadPr; }
    public double getPrecioPr() { return precioPr; }
    public void setPrecioPr(double precioPr) { this.precioPr = precioPr; }
    public boolean isEstadoPr() { return estadoPr; }
    public void setEstadoPr(boolean estadoPr) { this.estadoPr = estadoPr; }
}