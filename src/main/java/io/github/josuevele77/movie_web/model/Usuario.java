package io.github.josuevele77.movie_web.model;

public class Usuario {
    private int idUs;
    private int idPer; // Rol: 1=Admin, 2=Empleado, 3=Cliente
    private int idEst; // Estado Civil
    private String nombreUs;
    private String cedulaUs;
    private String correoUs;
    private String claveUs;
    private String avatarUrl;


    // Constructores, Getters y Setters
    public Usuario() {}

    public int getIdUs() { return idUs; }
    public void setIdUs(int idUs) { this.idUs = idUs; }
    public int getIdPer() { return idPer; }
    public void setIdPer(int idPer) { this.idPer = idPer; }
    public int getIdEst() { return idEst; }
    public void setIdEst(int idEst) { this.idEst = idEst; }
    public String getNombreUs() { return nombreUs; }
    public void setNombreUs(String nombreUs) { this.nombreUs = nombreUs; }
    public String getCedulaUs() { return cedulaUs; }
    public void setCedulaUs(String cedulaUs) { this.cedulaUs = cedulaUs; }
    public String getCorreoUs() { return correoUs; }
    public void setCorreoUs(String correoUs) { this.correoUs = correoUs; }
    public String getClaveUs() { return claveUs; }
    public void setClaveUs(String claveUs) { this.claveUs = claveUs; }
    public String getAvatarUrl() { return avatarUrl; }
    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }

}