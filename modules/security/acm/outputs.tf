output "certificate_arn" {
  description = "ACM 인증서 ARN"
  value       = aws_acm_certificate.cert.arn
}