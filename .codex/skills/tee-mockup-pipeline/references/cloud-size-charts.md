# Cloud size-chart transport mirror

This reference defines only how an ephemeral web/cloud Scheduled task copies the already-approved final `07.jpg` JPEG into a Google Drive delivery. It does not create, replace, summarize, or alter a size-chart rule. The current `AGENTS.md` remains authoritative, and local/project runs continue to use, byte-copy, and hash `assets/size-charts/` directly.

## Configured Drive mirror

The exact approved repository JPEGs are mirrored as ordinary binary files in this private Google Drive folder:

- Folder: `TeeVybe Cloud Templates`
- Folder ID: `10uUj5Zli_2RDVXKNEHP0gp-St3Z5CDKL`
- URL: `https://drive.google.com/drive/folders/10uUj5Zli_2RDVXKNEHP0gp-St3Z5CDKL`

Use only the profile-matched file below:

| Locked profile | Exact filename | Drive file ID |
| --- | --- | --- |
| `oversized fit` | `Oversized T-Shirt Size Chart.jpg` | `1Om8WMdCL9nKCZgStuIpbXxsTZFbWtsJu` |
| `regular fit` | `Regular T-Shirt Size Chart.jpg` | `14YfdW-YPd6ZXUH8ken65cSYOHzoUTU1T` |
| `polo fit` | `POLO T-Shirt Size Chart.jpg` | `1K0-MC4rs3-X3BjXyqQy43Zxsdu5EvgLv` |

Every listed source is an `image/jpeg` file with exact dimensions `1080 x 1440`.

## Mandatory cloud direct-copy procedure

1. Ground the configured template folder and the profile-matched source through Google Drive metadata. Match the locked fit to the exact filename and file ID in the table, require that exact parent folder, and require `image/jpeg` MIME type.
2. Before generation, verify that the connected Drive service exposes its native file-copy action and that the configured delivery root can be read and written. Do not make a test copy.
3. Do not fetch the chart through GitHub, download or materialize its binary, request inline base64, calculate a per-run chart checksum, or upload a separately obtained chart.
4. After the final batch folder and its `Men` and `Women` folders exist, invoke the native Drive copy action twice using the same approved source file ID: copy it into `Men` titled exactly `07.jpg`, then copy it into `Women` titled exactly `07.jpg`.
5. Record both copy operations' returned source/destination evidence. List/read back both gender folders and verify each contains exactly one direct JPEG child named `07.jpg` in addition to `01.jpg` through `06.jpg`.
6. Reject any wrong source ID, wrong fit mapping, wrong parent, wrong destination, unexpected filename/MIME type, duplicate `07.jpg`, conversion, generated chart, recreation, upload, or modification.

The Drive files are transport mirrors, not alternate templates. The native Drive copy plus destination readback is the cloud-only proof that the approved source was reused unchanged; per-run byte comparison and SHA-256 are intentionally not required in this path. If native Drive copy or destination readback is unavailable, stop before image generation and report that exact capability failure. Local/project runs do not use this exception.
