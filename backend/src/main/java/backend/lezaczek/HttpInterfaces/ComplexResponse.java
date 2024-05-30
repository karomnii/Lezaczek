package backend.lezaczek.HttpInterfaces;

import java.util.Map;

import lombok.Getter;

public class ComplexResponse extends Response {
    @Getter private Map<String, String> responseData;
    public ComplexResponse(Map<String, String> properites){
        super("ok");
        this.responseData = properites;
    }

    public String toJsonString(){
        String result = "{" + super.toString() + ",";
        for (Object key : responseData.keySet()) {
            result +="\"" + key + "\":\"" + responseData.get(key) + "\",";
        }
        return result.substring(0, result.length()-1) + "}";

    }
    public void append(String key, String value) {
        this.responseData.put(key, value);
    }
}