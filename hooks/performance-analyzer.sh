#!/bin/bash
# Post-Session Performance Analyzer for Claude Code
# Analyzes execution patterns and identifies optimization opportunities

set -e

# Configuration
LOG_DIR="${CLAUDE_HOME:-$HOME/.claude}/logs"
ANALYSIS_DIR="${CLAUDE_HOME:-$HOME/.claude}/analytics"
SESSION_LOG="${1:-$LOG_DIR/last-session.log}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Create analytics directory
mkdir -p "$ANALYSIS_DIR"

echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo -e "${BLUE}    Claude Code Performance Analysis${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo

# Function to analyze parallel vs serial execution
analyze_execution_patterns() {
    echo -e "${YELLOW}▶ Analyzing Execution Patterns...${NC}"
    
    local parallel_count=0
    local serial_count=0
    local tool_calls=()
    local timestamps=()
    
    # Parse session log for tool calls
    while IFS= read -r line; do
        if [[ $line =~ "Tool:" ]] || [[ $line =~ "Task:" ]]; then
            tool_calls+=("$line")
            timestamps+=($(echo "$line" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}' || echo ""))
        fi
    done < "$SESSION_LOG"
    
    # Detect parallel execution (multiple tools within same timestamp window)
    local last_time=""
    local batch_size=0
    
    for i in "${!timestamps[@]}"; do
        if [[ "${timestamps[$i]}" == "$last_time" ]] || [[ -z "$last_time" ]]; then
            ((batch_size++))
        else
            if [[ $batch_size -gt 1 ]]; then
                ((parallel_count += batch_size))
            else
                ((serial_count++))
            fi
            batch_size=1
        fi
        last_time="${timestamps[$i]}"
    done
    
    # Final batch
    if [[ $batch_size -gt 1 ]]; then
        ((parallel_count += batch_size))
    else
        ((serial_count++))
    fi
    
    local total=$((parallel_count + serial_count))
    local parallel_pct=0
    if [[ $total -gt 0 ]]; then
        parallel_pct=$((parallel_count * 100 / total))
    fi
    
    echo "  📊 Parallel Operations: $parallel_count ($parallel_pct%)"
    echo "  🔄 Serial Operations: $serial_count"
    echo "  📈 Total Operations: $total"
    echo
    
    # Generate recommendation
    if [[ $parallel_pct -lt 70 ]]; then
        echo -e "  ${RED}⚠️  Low parallelization detected!${NC}"
        echo "  Recommendation: Batch more operations together"
    else
        echo -e "  ${GREEN}✅ Good parallelization rate${NC}"
    fi
    echo
}

# Function to identify optimization opportunities
identify_optimizations() {
    echo -e "${YELLOW}▶ Identifying Optimization Opportunities...${NC}"
    
    local issues_found=0
    
    # Check for multiple edits to same file
    echo -n "  Checking for multiple edits to same file... "
    local edit_files=$(grep -E "Edit:.*file_path" "$SESSION_LOG" 2>/dev/null | grep -oE '/[^"]+' | sort | uniq -c | sort -rn)
    
    while IFS= read -r line; do
        local count=$(echo "$line" | awk '{print $1}')
        local file=$(echo "$line" | awk '{$1=""; print $0}' | xargs)
        
        if [[ $count -gt 1 ]] && [[ -n "$file" ]]; then
            if [[ $issues_found -eq 0 ]]; then
                echo
            fi
            echo -e "    ${YELLOW}⚠️  $count edits to $file - should use MultiEdit${NC}"
            ((issues_found++))
        fi
    done <<< "$edit_files"
    
    if [[ $issues_found -eq 0 ]]; then
        echo -e "${GREEN}✓${NC}"
    fi
    
    # Check for sequential directory operations
    echo -n "  Checking for sequential directory operations... "
    local mkdir_count=$(grep -c "mkdir" "$SESSION_LOG" 2>/dev/null || echo 0)
    local rmdir_count=$(grep -c "rmdir\|rm -" "$SESSION_LOG" 2>/dev/null || echo 0)
    
    if [[ $mkdir_count -gt 2 ]] || [[ $rmdir_count -gt 2 ]]; then
        echo
        echo -e "    ${YELLOW}⚠️  Found $mkdir_count mkdir and $rmdir_count rm operations${NC}"
        echo "    Consider: mkdir -p dir1 dir2 dir3 && rm -f file1 file2"
        ((issues_found++))
    else
        echo -e "${GREEN}✓${NC}"
    fi
    
    # Check for delayed reads
    echo -n "  Checking for delayed file reads... "
    local glob_then_read=$(grep -B5 "Read:" "$SESSION_LOG" | grep -c "Glob:" || echo 0)
    
    if [[ $glob_then_read -gt 3 ]]; then
        echo
        echo -e "    ${YELLOW}⚠️  Files discovered then read separately${NC}"
        echo "    Consider: Reading files during discovery"
        ((issues_found++))
    else
        echo -e "${GREEN}✓${NC}"
    fi
    
    echo
    echo "  Total optimization opportunities found: $issues_found"
    echo
}

# Function to generate performance report
generate_report() {
    local report_file="$ANALYSIS_DIR/performance_${TIMESTAMP}.md"
    
    echo -e "${YELLOW}▶ Generating Performance Report...${NC}"
    
    cat > "$report_file" << EOF
# Performance Analysis Report
**Generated:** $(date)
**Session:** $SESSION_LOG

## Execution Statistics

\`\`\`
$(analyze_execution_patterns 2>&1)
\`\`\`

## Optimization Opportunities

$(identify_optimizations 2>&1)

## Anti-Patterns Detected

$(grep -E "Multiple.*same file|Sequential.*operations|Delayed.*reads" "$SESSION_LOG" 2>/dev/null || echo "None detected")

## Recommendations

1. **Use MultiEdit** for multiple changes to the same file
2. **Batch filesystem operations** into single commands
3. **Read during discovery** rather than after
4. **Parallelize independent operations** in single message

## Performance Score

$(calculate_score)

---
*Generated by Claude Framework Performance Analyzer*
EOF

    echo "  Report saved to: $report_file"
    echo
}

# Function to calculate performance score
calculate_score() {
    local score=100
    local deductions=""
    
    # Deduct for low parallelization
    local parallel_pct=$(analyze_execution_patterns | grep "Parallel Operations" | grep -oE '[0-9]+%' | tr -d '%')
    if [[ $parallel_pct -lt 70 ]]; then
        ((score -= 20))
        deductions+="\n  -20: Low parallelization ($parallel_pct%)"
    fi
    
    # Deduct for multiple edits to same file
    local multi_edits=$(grep -c "should use MultiEdit" "$SESSION_LOG" 2>/dev/null || echo 0)
    if [[ $multi_edits -gt 0 ]]; then
        ((score -= multi_edits * 5))
        deductions+="\n  -$((multi_edits * 5)): Multiple edits to same file ($multi_edits instances)"
    fi
    
    # Deduct for sequential operations
    local seq_ops=$(grep -c "Sequential.*operations" "$SESSION_LOG" 2>/dev/null || echo 0)
    if [[ $seq_ops -gt 0 ]]; then
        ((score -= 10))
        deductions+="\n  -10: Sequential filesystem operations"
    fi
    
    echo "**Score: $score/100**"
    
    if [[ -n "$deductions" ]]; then
        echo -e "\nDeductions:$deductions"
    fi
    
    if [[ $score -ge 90 ]]; then
        echo -e "\n✅ **Excellent performance!**"
    elif [[ $score -ge 70 ]]; then
        echo -e "\n⚠️ **Good performance with room for improvement**"
    else
        echo -e "\n❌ **Significant optimization opportunities available**"
    fi
}

# Function to track trends
track_trends() {
    echo -e "${YELLOW}▶ Tracking Performance Trends...${NC}"
    
    local trends_file="$ANALYSIS_DIR/trends.csv"
    
    # Initialize CSV if it doesn't exist
    if [[ ! -f "$trends_file" ]]; then
        echo "timestamp,parallel_pct,serial_count,optimization_opportunities,score" > "$trends_file"
    fi
    
    # Calculate current metrics
    local parallel_pct=$(analyze_execution_patterns | grep "Parallel Operations" | grep -oE '[0-9]+%' | tr -d '%')
    local serial_count=$(analyze_execution_patterns | grep "Serial Operations" | grep -oE '[0-9]+')
    local opt_opportunities=$(identify_optimizations | grep "Total optimization" | grep -oE '[0-9]+')
    local score=$(calculate_score | grep "Score:" | grep -oE '[0-9]+')
    
    # Append to trends
    echo "$TIMESTAMP,$parallel_pct,$serial_count,$opt_opportunities,$score" >> "$trends_file"
    
    # Show last 5 sessions trend
    echo "  Recent performance trend:"
    tail -5 "$trends_file" | column -t -s','
    echo
}

# Main execution
main() {
    # Check if session log exists
    if [[ ! -f "$SESSION_LOG" ]]; then
        echo -e "${RED}Error: Session log not found at $SESSION_LOG${NC}"
        echo "Usage: $0 [session-log-file]"
        exit 1
    fi
    
    # Run analysis
    analyze_execution_patterns
    identify_optimizations
    track_trends
    generate_report
    
    echo -e "${GREEN}✅ Analysis complete!${NC}"
    echo
    
    # Show quick summary
    echo -e "${BLUE}Quick Summary:${NC}"
    calculate_score
}

# Run main function
main "$@"