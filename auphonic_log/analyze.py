import json

import pandas as pd
import plotly.express as px


def main():
    json_dict = json.load(open('log.json'))
    data = {
        'Episode Number': [],
        'Loudness (LUFS)': []
    }

    for k, v in json_dict.items():
        fname = v['files']['input']['filename']
        in_loudness, in_unit  = v['statistics']['levels']['input']['loudness']
        out_loudness, out_unit = v['statistics']['levels']['output']['loudness']

        # print(f"{fname}: {in_loudness} -> {out_loudness}")

        data['Episode Number'].append(float(fname.replace('.mp3', '')))
        data['Loudness (LUFS)'].append(in_loudness)

    df = pd.DataFrame(data)
    df = df.sort_values('Episode Number')


    fig = px.histogram(df, x='Loudness (LUFS)')
    #fig.show()
    fig.write_image('hist.png')

    fig2 = px.line(df, x='Episode Number', y='Loudness (LUFS)', )
    #fig2.show()
    fig2.write_image('line.png')

    fig3 = px.scatter(df, x='Episode Number', y='Loudness (LUFS)', )
    #fig3.show()
    fig3.write_image('scatter.png')


if __name__ == '__main__':
    main()