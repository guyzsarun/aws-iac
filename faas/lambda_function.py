import json

def lambda_handler(event, context):
    print("Received event: " + json.dumps(event))

    if 'body' in event and isinstance(event['body'], str):
        data = json.loads(event['body'])
    else:
        data = event

    op = data.get('op')
    a = data.get('a')
    b = data.get('b')

    if None in (op, a, b):
        return {
            'statusCode': 400,
            'body': json.dumps({"error": "Missing parameters. Need 'a', 'b', and 'op'."})
        }

    try:
        a, b = int(a), int(b)
        match op:
            case "+": result = a + b
            case "-": result = a - b
            case "*": result = a * b
            case "/": result = a / b if b != 0 else "Error: Div by zero"
            case _: result = "Error: Unknown operator"
    except ValueError:
        result = "Error: 'a' and 'b' must be numeric"
    return {
        'statusCode': 200,
        'body': json.dumps({"result": result})
    }