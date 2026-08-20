# 自动备份脚本：每天把知识库推到 Gitee
# 用法：powershell -File backup_to_gitee.ps1

$repo = "C:\Users\Administrator\Desktop\我的文档仓库"
Set-Location $repo

# 检查是否有改动
$status = git status --porcelain
if ($status) {
    git add -A
    $date = Get-Date -Format "yyyy-MM-dd"
    git commit -m "chore: 每日自动备份 $date" | Out-Null
    
    # 推 Gitee（已配好 token）
    git push gitee main 2>&1
    
    # 顺手试推 GitHub（网络不通就跳过，不报错）
    git push origin main 2>&1 | Out-Null
    
    Write-Output "✅ 备份完成：$(Get-Date)"
} else {
    Write-Output "ℹ️ 无改动，跳过"
}
