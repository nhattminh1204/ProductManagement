# JJWT 0.12.3 Migration Guide

## Vấn đề

Khi nâng cấp lên JJWT 0.12.3, nhiều API đã thay đổi và các phương thức cũ đã bị deprecated hoặc xóa bỏ.

## Lỗi gặp phải

```
[ERROR] cannot find symbol
  symbol:   method parserBuilder()
  location: class io.jsonwebtoken.Jwts
```

## Các thay đổi chính

### 1. Import Statements

**Trước (Old):**
```java
import io.jsonwebtoken.SignatureAlgorithm;
import java.security.Key;
```

**Sau (New):**
```java
import javax.crypto.SecretKey;
// Không cần import SignatureAlgorithm nữa
```

### 2. Signing Key Type

**Trước (Old):**
```java
private Key getSigningKey() {
    return Keys.hmacShaKeyFor(secret.getBytes());
}
```

**Sau (New):**
```java
private SecretKey getSigningKey() {
    return Keys.hmacShaKeyFor(secret.getBytes());
}
```

### 3. Token Generation (Builder Pattern)

**Trước (Old):**
```java
return Jwts.builder()
        .setClaims(claims)           // setClaims()
        .setSubject(email)            // setSubject()
        .setIssuedAt(new Date())      // setIssuedAt()
        .setExpiration(new Date(...)) // setExpiration()
        .signWith(getSigningKey(), SignatureAlgorithm.HS256)
        .compact();
```

**Sau (New):**
```java
return Jwts.builder()
        .claims(claims)               // claims() - không có "set"
        .subject(email)               // subject() - không có "set"
        .issuedAt(new Date())         // issuedAt() - không có "set"
        .expiration(new Date(...))    // expiration() - không có "set"
        .signWith(getSigningKey())    // Không cần SignatureAlgorithm
        .compact();
```

### 4. Token Parsing

**Trước (Old):**
```java
return Jwts.parserBuilder()           // parserBuilder()
        .setSigningKey(getSigningKey()) // setSigningKey()
        .build()
        .parseClaimsJws(token)        // parseClaimsJws()
        .getBody();                   // getBody()
```

**Sau (New):**
```java
return Jwts.parser()                  // parser() - không có "Builder"
        .verifyWith(getSigningKey())  // verifyWith() thay vì setSigningKey()
        .build()
        .parseSignedClaims(token)     // parseSignedClaims() thay vì parseClaimsJws()
        .getPayload();                // getPayload() thay vì getBody()
```

## Tóm tắt thay đổi API

| Old API (< 0.12.x) | New API (0.12.3+) | Ghi chú |
|-------------------|-------------------|---------|
| `parserBuilder()` | `parser()` | Đơn giản hóa tên |
| `setSigningKey()` | `verifyWith()` | Tên rõ ràng hơn |
| `parseClaimsJws()` | `parseSignedClaims()` | Tên nhất quán hơn |
| `getBody()` | `getPayload()` | Thuật ngữ chuẩn JWT |
| `setClaims()` | `claims()` | Loại bỏ prefix "set" |
| `setSubject()` | `subject()` | Loại bỏ prefix "set" |
| `setIssuedAt()` | `issuedAt()` | Loại bỏ prefix "set" |
| `setExpiration()` | `expiration()` | Loại bỏ prefix "set" |
| `signWith(key, algorithm)` | `signWith(key)` | Algorithm tự động detect |
| `Key` | `SecretKey` | Type cụ thể hơn |
| `SignatureAlgorithm.HS256` | Không cần | Auto-detect từ key |

## File đã sửa

- `src/main/java/com/husc/productmanagement/util/JwtUtil.java`

## Testing

Sau khi sửa, test các chức năng:

1. **Đăng ký tài khoản**
```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@example.com",
    "phone": "0123456789",
    "password": "password123"
  }'
```

2. **Đăng nhập**
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

3. **Sử dụng token**
```bash
curl -X GET http://localhost:8080/api/users \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## Tài liệu tham khảo

- [JJWT GitHub](https://github.com/jwtk/jjwt)
- [JJWT 0.12.0 Release Notes](https://github.com/jwtk/jjwt/releases/tag/0.12.0)
- [Migration Guide](https://github.com/jwtk/jjwt#migration)

## Lưu ý quan trọng

1. **Breaking Changes**: JJWT 0.12.x có nhiều breaking changes so với 0.11.x
2. **Type Safety**: Sử dụng `SecretKey` thay vì `Key` cho type safety tốt hơn
3. **Auto-detection**: Algorithm được tự động detect từ key, không cần chỉ định rõ
4. **Fluent API**: API mới ngắn gọn hơn, loại bỏ prefix "set"
5. **Backward Compatibility**: Không tương thích ngược với code cũ

## Build & Run

```bash
# Clean và compile
mvn clean compile

# Chạy ứng dụng
mvn spring-boot:run

# Hoặc build JAR
mvn clean package
java -jar target/product-management-1.0.0.jar
```
