using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyPatrolAI : MonoBehaviour {

	public enum EnemyAIState {
		Patrol = 0,
		Chase = 1,
		Search = 2
	}

	public Transform[] patrolPoints;
	public float speed;
	public EnemyAIState currentAIState;
	public Transform player;

	Transform currentPatrolPointTarget;
	int currentPatrolPointTargetIndex;

	private float rayAngle = 4;
	private float rayDistance = 170;
	private string playerObjectName = "Player";

	// Use this for initialization
	void Start () {
		currentPatrolPointTarget = patrolPoints [0];
		currentPatrolPointTargetIndex = 0;
		currentAIState = EnemyAIState.Patrol;
	}
	
	// Update is called once per frame
	void Update () {
		switch (currentAIState) {
		case EnemyAIState.Patrol:
			UpdatePatrollingEnemy ();
			break;
		case EnemyAIState.Chase:
			UpdateChasingEnemy ();
			break;
		case EnemyAIState.Search:
			UpdateSearchingEnemy ();
			break;
		}
	}

	void UpdatePatrollingEnemy() {
		transform.Translate (Vector3.up * Time.deltaTime * speed);

		if (Vector3.Distance (transform.position, currentPatrolPointTarget.position) < 1f) {
			if (currentPatrolPointTargetIndex + 1 < patrolPoints.Length) {
				currentPatrolPointTargetIndex++;
			} else {
				currentPatrolPointTargetIndex = 0;
			}
			currentPatrolPointTarget = patrolPoints [currentPatrolPointTargetIndex];
		}

		Vector3 patrolPointDirection = currentPatrolPointTarget.position - transform.position;
		float angle = Mathf.Atan2 (patrolPointDirection.y, patrolPointDirection.x) * Mathf.Rad2Deg - 90f;

		Quaternion q = Quaternion.AngleAxis (angle, Vector3.forward);
		transform.rotation = Quaternion.RotateTowards (transform.rotation, q, 180f);

		if (CheckForPlayer()) {
			currentAIState = EnemyAIState.Chase;
			Debug.Log ("State is now set to chasing.");
		}
	}

	void UpdateChasingEnemy() {
		Vector3 playerDirection = player.position - transform.position;
		float angle = Mathf.Atan2 (playerDirection.y, playerDirection.x) * Mathf.Rad2Deg - 90f;

		Quaternion q = Quaternion.AngleAxis (angle, Vector3.forward);
		transform.rotation = Quaternion.RotateTowards (transform.rotation, q, 180f);
		transform.position += transform.up * speed * Time.deltaTime;

		if (!CheckForPlayer ()) {
			currentAIState = EnemyAIState.Patrol;
		}
	}

	void UpdateSearchingEnemy() {
		Debug.Log ("Searching for Player");
	}

	bool CheckForPlayer() {
		for (int i = -1; i < 2; i++) {
			Vector2 rayDirection = Quaternion.AngleAxis (i * rayAngle, Vector3.forward) * transform.up;
			RaycastHit2D hit = Physics2D.Raycast (transform.position, rayDirection, rayDistance);

			if (hit.collider != null) {
				Debug.DrawRay (transform.position, hit.point - new Vector2 (transform.position.x, transform.position.y), Color.green);
				Debug.Log ("Player found");
				return hit.collider.gameObject.name == playerObjectName;
			} else {
				Debug.DrawRay (transform.position, rayDirection * rayDistance, Color.red);
				return false;
			}
		}
		return false;
	}
}
