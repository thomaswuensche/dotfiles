function runJs() {
  var from = document.getElementById('fromInput').value;
  var to = document.getElementById('toInput').value;
  var json = JSON.stringify(
    wFN(from, to),
    null,
    2);
  document.getElementById('jsonPre').innerHTML = json;
}

function wFN(from, to) {
  return [
    {
      from: {
        modifiers: {
          optional: ['any'],
        },
        simultaneous: [
          {
            key_code: 'w',
          },
          {
            key_code: from,
          },
        ],
        simultaneous_options: {
          key_down_order: 'strict',
          key_up_order: 'strict_inverse',
          to_after_key_up: [
            {
              set_variable: {
                name: 'wFN',
                value: 0,
              },
            },
          ],
        },
      },
      parameters: {
        'basic.simultaneous_threshold_milliseconds': 500 /* Default: 1000 */,
      },
      to: [
        {
          set_variable: {
            name: 'wFN',
            value: 1,
          },
        },
        {
          key_code: to,
        },
      ],
      type: 'basic',
    },
    {
      conditions: [
        {
          name: 'wFN',
          type: 'variable_if',
          value: 1,
        },
      ],
      from: {
        key_code: from,
        modifiers: {
          optional: ['any'],
        },
      },
      to: [
        {
          key_code: to,
        },
      ],
      type: 'basic',
    },
  ];
}
