package backend.lezaczek.HttpInterfaces;

import lombok.Getter;

public class Response {
    @Getter
    private String result;

    public Response(String response) {
        this.result = response;
    }

    @Override
    public String toString() {
        return "\"result\":\"" + this.result + "\"";
    }
}