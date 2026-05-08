#!/usr/bin/env python3
"""Generate a polished HTML dashboard from a Flutter integration_test performance report.

The script reads the JSON summary produced by `TimelineSummary.writeTimelineToFile`
and writes a self-contained HTML report with a few useful charts.

Usage:
  python scripts/visualize_performance_report.py
  python scripts/visualize_performance_report.py build/my_performance_report.json
  python scripts/visualize_performance_report.py build/my_performance_report.json --output build/my_performance_report.html
"""

from __future__ import annotations

import argparse
import html
import json
from pathlib import Path
from typing import Any


DEFAULT_INPUT = Path("build/my_performance_report.json")


def _fmt_value(value: Any) -> str:
    if isinstance(value, float):
        return f"{value:.3f}"
    if isinstance(value, int):
        return str(value)
    return html.escape(str(value))


def _metric_cards(metrics: dict[str, Any]) -> str:
    key_groups = [
        ("Frames", ["frame_count", "frame_rasterizer_count"]),
        ("Build", ["average_frame_build_time_millis", "worst_frame_build_time_millis"]),
        ("Rasterizer", ["average_frame_rasterizer_time_millis", "worst_frame_rasterizer_time_millis"]),
        ("Budget", ["missed_frame_build_budget_count", "missed_frame_rasterizer_budget_count"]),
        ("Latency", ["average_frame_request_pending_latency", "worst_layer_cache_count"]),
    ]

    cards: list[str] = []
    for group_title, keys in key_groups:
        for key in keys:
            if key not in metrics:
                continue
            value = _fmt_value(metrics[key])
            cards.append(
                f"""
                <div class="card">
                  <div class="card-kicker">{html.escape(group_title)}</div>
                  <div class="card-value">{value}</div>
                  <div class="card-label">{html.escape(key)}</div>
                </div>
                """
            )

    return "\n".join(cards)


def _table_rows(metrics: dict[str, Any]) -> str:
    rows = []
    for key in sorted(metrics):
        if key.endswith("_times") or key.endswith("_begin_times"):
            continue
        value = metrics[key]
        if isinstance(value, list):
            continue
        rows.append(
            f"<tr><td>{html.escape(key)}</td><td>{_fmt_value(value)}</td></tr>"
        )
    return "\n".join(rows)


def build_html(report: dict[str, Any], title: str) -> str:
    build_times = report.get("frame_build_times", [])
    raster_times = report.get("frame_rasterizer_times", [])

    bar_labels = [
        "avg build",
        "p90 build",
        "p99 build",
        "worst build",
        "avg raster",
        "p90 raster",
        "p99 raster",
        "worst raster",
        "avg request latency",
    ]
    bar_values = [
        report.get("average_frame_build_time_millis", 0),
        report.get("90th_percentile_frame_build_time_millis", 0),
        report.get("99th_percentile_frame_build_time_millis", 0),
        report.get("worst_frame_build_time_millis", 0),
        report.get("average_frame_rasterizer_time_millis", 0),
        report.get("90th_percentile_frame_rasterizer_time_millis", 0),
        report.get("99th_percentile_frame_rasterizer_time_millis", 0),
        report.get("worst_frame_rasterizer_time_millis", 0),
        report.get("average_frame_request_pending_latency", 0),
    ]

    html_body = f"""<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>{html.escape(title)}</title>
  <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
  <style>
    :root {{
      --bg: #0b1020;
      --panel: rgba(15, 23, 42, 0.84);
      --panel-2: rgba(30, 41, 59, 0.72);
      --text: #e2e8f0;
      --muted: #94a3b8;
      --accent: #7dd3fc;
      --accent-2: #f59e0b;
      --danger: #fb7185;
      --line: rgba(148, 163, 184, 0.16);
      --shadow: 0 24px 70px rgba(2, 6, 23, 0.45);
    }}
    * {{ box-sizing: border-box; }}
    body {{
      margin: 0;
      font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
      background:
        radial-gradient(circle at top left, rgba(125, 211, 252, 0.16), transparent 30%),
        radial-gradient(circle at top right, rgba(245, 158, 11, 0.12), transparent 28%),
        linear-gradient(180deg, #060914 0%, #0b1020 100%);
      color: var(--text);
      min-height: 100vh;
    }}
    .wrap {{ max-width: 1400px; margin: 0 auto; padding: 32px 20px 40px; }}
    .hero {{
      display: grid;
      gap: 12px;
      margin-bottom: 24px;
      padding: 24px;
      border: 1px solid var(--line);
      background: linear-gradient(180deg, rgba(15, 23, 42, 0.94), rgba(15, 23, 42, 0.72));
      border-radius: 24px;
      box-shadow: var(--shadow);
    }}
    .eyebrow {{ color: var(--accent); text-transform: uppercase; letter-spacing: .18em; font-size: 12px; font-weight: 700; }}
    h1 {{ margin: 0; font-size: clamp(28px, 5vw, 46px); line-height: 1.05; }}
    .sub {{ margin: 0; color: var(--muted); max-width: 85ch; line-height: 1.55; }}
    .grid {{ display: grid; gap: 16px; }}
    .cards {{ grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); }}
    .card, .panel {{
      border: 1px solid var(--line);
      background: var(--panel);
      border-radius: 20px;
      box-shadow: var(--shadow);
    }}
    .card {{ padding: 18px; min-height: 132px; }}
    .card-kicker {{ color: var(--accent); font-size: 12px; font-weight: 700; letter-spacing: .12em; text-transform: uppercase; }}
    .card-value {{ margin-top: 12px; font-size: 32px; font-weight: 800; }}
    .card-label {{ margin-top: 8px; color: var(--muted); font-size: 13px; word-break: break-word; }}
    .panels {{ grid-template-columns: 1.5fr 1fr; align-items: start; }}
    .panel {{ padding: 18px; }}
    .panel h2 {{ margin: 0 0 10px; font-size: 18px; }}
    .panel p {{ margin: 0 0 14px; color: var(--muted); font-size: 14px; line-height: 1.5; }}
    canvas {{ width: 100% !important; height: 320px !important; }}
    table {{ width: 100%; border-collapse: collapse; font-size: 13px; }}
    td {{ padding: 10px 0; border-bottom: 1px solid var(--line); vertical-align: top; }}
    td:first-child {{ color: var(--muted); width: 58%; padding-right: 16px; }}
    .two {{ grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); }}
    .note {{ color: var(--muted); font-size: 12px; margin-top: 10px; }}
    @media (max-width: 960px) {{ .panels {{ grid-template-columns: 1fr; }} }}
  </style>
</head>
<body>
  <div class="wrap">
    <section class="hero">
      <div class="eyebrow">Flutter Performance Report</div>
      <h1>{html.escape(title)}</h1>
      <p class="sub">This dashboard summarizes frame build and rasterization timings from your integration test, with a focus on the measured action window only. It is intentionally lightweight and self-contained so you can open it directly in a browser.</p>
    </section>

    <section class="grid cards">
      {_metric_cards(report)}
    </section>

    <section class="grid panels" style="margin-top:16px;">
      <article class="panel">
        <h2>Key Timing Metrics</h2>
        <p>Average, percentile, and worst-case timings for build, rasterizer, and request latency.</p>
        <canvas id="summaryChart"></canvas>
      </article>

      <article class="panel">
        <h2>Report Summary</h2>
        <p>Useful when you want a compact, machine-readable inventory of the same data.</p>
        <table>
          <tbody>
            {_table_rows(report)}
          </tbody>
        </table>
      </article>
    </section>

    <section class="grid two" style="margin-top:16px;">
      <article class="panel">
        <h2>Frame Build Times</h2>
        <p>Per-frame build time sequence in microseconds converted to milliseconds.</p>
        <canvas id="buildChart"></canvas>
      </article>

      <article class="panel">
        <h2>Frame Rasterizer Times</h2>
        <p>Per-frame rasterizer time sequence in microseconds converted to milliseconds.</p>
        <canvas id="rasterChart"></canvas>
      </article>
    </section>

    <p class="note">Source: {html.escape(str(report.get('_source', DEFAULT_INPUT)))}</p>
  </div>

  <script>
    const summaryLabels = {json.dumps(bar_labels)};
    const summaryValues = {json.dumps(bar_values)};
    const buildValues = {json.dumps(build_times)};
    const rasterValues = {json.dumps(raster_times)};

    const baseGrid = {{ color: 'rgba(148, 163, 184, 0.14)' }};
    const commonTooltip = {{
      backgroundColor: 'rgba(15, 23, 42, 0.94)',
      titleColor: '#e2e8f0',
      bodyColor: '#cbd5e1',
      borderColor: 'rgba(148, 163, 184, 0.22)',
      borderWidth: 1,
      padding: 12,
    }};

    new Chart(document.getElementById('summaryChart'), {{
      type: 'bar',
      data: {{
        labels: summaryLabels,
        datasets: [{{
          label: 'ms',
          data: summaryValues,
          borderWidth: 0,
          borderRadius: 10,
          backgroundColor: ['#7dd3fc', '#38bdf8', '#0ea5e9', '#0369a1', '#f59e0b', '#f97316', '#fb7185', '#e11d48', '#22c55e'],
        }}],
      }},
      options: {{
        responsive: true,
        maintainAspectRatio: false,
        plugins: {{ legend: {{ display: false }}, tooltip: commonTooltip }},
        scales: {{
          x: {{ ticks: {{ color: '#cbd5e1' }}, grid: {{ display: false }} }},
          y: {{ ticks: {{ color: '#cbd5e1' }}, grid: baseGrid }},
        }},
      }},
    }});

    const lineDefaults = {{
      responsive: true,
      maintainAspectRatio: false,
      plugins: {{ legend: {{ labels: {{ color: '#e2e8f0' }} }}, tooltip: commonTooltip }},
      scales: {{
        x: {{ ticks: {{ color: '#cbd5e1' }}, grid: {{ display: false }} }},
        y: {{ ticks: {{ color: '#cbd5e1' }}, grid: baseGrid }},
      }},
      elements: {{ line: {{ tension: 0.35, borderWidth: 3 }}, point: {{ radius: 4, hoverRadius: 6 }} }},
    }};

    new Chart(document.getElementById('buildChart'), {{
      type: 'line',
      data: {{
        labels: buildValues.map((_, index) => 'Frame ' + (index + 1)),
        datasets: [{{
          label: 'Build ms',
          data: buildValues.map(v => v / 1000),
          borderColor: '#7dd3fc',
          backgroundColor: 'rgba(125, 211, 252, 0.18)',
          fill: true,
        }}],
      }},
      options: lineDefaults,
    }});

    new Chart(document.getElementById('rasterChart'), {{
      type: 'line',
      data: {{
        labels: rasterValues.map((_, index) => 'Frame ' + (index + 1)),
        datasets: [{{
          label: 'Raster ms',
          data: rasterValues.map(v => v / 1000),
          borderColor: '#f59e0b',
          backgroundColor: 'rgba(245, 158, 11, 0.18)',
          fill: true,
        }}],
      }},
      options: lineDefaults,
    }});
  </script>
</body>
</html>
"""
    return html_body


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "input",
        nargs="?",
        default=str(DEFAULT_INPUT),
        help="Path to the performance report JSON.",
    )
    parser.add_argument(
        "--output",
        help="Path to the generated HTML file. Defaults to the input file with .html extension.",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    input_path = Path(args.input)
    if not input_path.exists():
        raise SystemExit(f"Input file not found: {input_path}")

    report = json.loads(input_path.read_text(encoding="utf-8"))
    report["_source"] = str(input_path)

    output_path = Path(args.output) if args.output else input_path.with_suffix(".html")
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(build_html(report, input_path.stem), encoding="utf-8")
    print(f"Wrote {output_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())