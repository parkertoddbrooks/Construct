# TODO: Standardize Automated File Naming Convention

## 📋 Task
Implement consistent naming convention for all automated files across CONSTRUCT.

## 🎯 Goal
Ensure all automatically generated files follow the standard format:
```
name-of-file--YEAR-MM-DD--HH-MM-SS.md
```

## 📐 Format Rules
- Two dashes (`--`) after the file name
- Two dashes (`--`) between date and time
- Date format: YYYY-MM-DD
- Time format: HH-MM-SS (24-hour)
- Always use `.md` extension for markdown files

## 📍 Files to Update
1. **Session Summary Script** (`session-summary.sh`)
   - Current: `2025-07-03-0830-construct-session.md`
   - Should be: `construct-session--2025-07-03--08-30-00.md`

2. **Quality Report Script** (`check-quality.sh`)
   - Current: `quality-report-2025-07-03--08-47-36.md`
   - Already correct! ✅

3. **Dev Update Script** (`generate-devupdate.sh`)
   - Current: Fixed to use `devupdate--YYYY-MM-DD--HH-MM-SS.md` ✅

4. **Structure Scan Script** (`scan_construct_structure.sh`)
   - Current: `construct-structure-2025-07-03--08-30-55.md`
   - Already correct! ✅

5. **Any future automated file generators**

## 🔧 Implementation Notes
- Update timestamp generation functions to use consistent format
- Consider creating a shared timestamp function in `lib/common-patterns.sh`
- Update any file listing/sorting logic to handle the new format
- Test that file archiving still works correctly

## 💡 Benefits
- Consistent sorting by name then date/time
- Clear visual separation between name and timestamp
- Easier to parse programmatically
- Professional appearance

## 🚀 Priority
Medium - Important for consistency but not blocking other work