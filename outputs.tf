output "vpc_id" {
  value = aws_vpc.prod-vpc.id
}

output "vpc_cidr_block" {
  value = aws_vpc.prod-vpc.cidr_block
}

output "public_subnet_1_id" {
  value = aws_subnet.public-subnet-1.id
}

output "public_subnet_2_id" {
    value = aws_subnet.public-subnet-2.id
}

output "public_subnet_3_id" {
    value = aws_subnet.public-subnet-3.id
}

output "private_subnet_1_id" {
    value = aws_subnet.private-subnet-1.id
}

output "private_subnet_2_id" {
    value = aws_subnet.private-subnet-2.id
}

output "private_subnet_3_id" {
    value = aws_subnet.private-subnet-3.id
}

output "private_subnets" {
  value = tolist([aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id, aws_subnet.private-subnet-3.id])
}

output "public_subnets" {
  value = tolist([aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id, aws_subnet.public-subnet-3.id])
}
