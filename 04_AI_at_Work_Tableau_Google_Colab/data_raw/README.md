# Raw source files

Raw provider files are not included. Download the release files linked in the main README and place them in these subfolders:

```text
data_raw/
  anthropic/aei_claude_ai_2026-06-26.csv
  openai/share_of_messages_by_country_quarter_rank.csv
  openai/share_of_messages_by_work_related_country_month.csv
  openai/share_of_messages_by_work_related_ask_do_express_country_month.csv
  microsoft/estimated-share-people-generative-ai.csv
  ilostat/GDP_2HRW_NOC_NB_A-20261008T2240.csv
```

The first notebook can instead read an existing project archive by setting `AI_CAPSTONE_RAW_DIR` or editing `RAW_DIR`. The older Drive folder with a leading space in ` openai` is recognised. An existing `anthropic_country_only.csv` can substitute for the full Anthropic source; it must come from the same release and retain the original columns.

Ipsos and Gallup values were transcribed for the selected 31 countries. Those entries are preserved in `data_clean/survey_values.csv`, with their definitions and report links in the main README. Original provider terms continue to apply. There is no need to upload the source PDFs.
