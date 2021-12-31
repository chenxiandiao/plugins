package io.flutter.plugins.x5webviewflutter.model;

import java.io.Serializable;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class PermissionDataInfo implements Serializable {
    private List<String> permissions;

    public Map<String, Object> toMap() {
        Map<String, Object> re = new HashMap<>();
        re.put("permissions", getPermissions());
        return re;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("{ permissions=" + getPermissions());
        sb.append(" }");
        return sb.toString();
    }

    public List<String> getPermissions() {
        return permissions;
    }

    public void setPermissions(List<String> permissions) {
        this.permissions = permissions;
    }
}
