function dist = distance3d(x1, y1, z1, x2, y2, z2)
    dx = x2 - x1;
    dy = y2 - y1;
    dz = z2 - z1;
    dist = sqrt(dx^2 + dy^2 + dz^2);
end